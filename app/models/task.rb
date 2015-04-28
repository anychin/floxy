class Task < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  belongs_to :milestone
  has_one :project, :through => :milestone
  has_one :organization, :through => :milestone
  has_one :team, :through => :project
  has_many :team_memberships, :through => :team
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level
  # belongs_to :user_invoice

  has_many :task_transitions, dependent: :destroy

  scope :ordered_by_id, -> { order("id asc") }
  scope :without_milestone, ->{ where(milestone_id: nil) }
  scope :user_uninvoiced, -> {where(:user_invoice_id => nil)}
  # scope :user_invoiced, -> {where('user_invoice_id is not null')}

  scope :by_team_user, ->(user) {
    joins{team_memberships.outer}.merge(Project.by_team_user(user))
  }

  scope :ordered_by_created_at, ->{order(:created_at)}
  scope :by_assigned_user, ->(user) {where(assignee_id: user.id)}

  validates :milestone, :owner, :title, presence: true
  validates :estimated_time, numericality: { less_than_or_equal_to: 8 }

  def state_machine
     @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events,
           to: :state_machine

  delegate :rate_value, to: :task_level, allow_nil: true
  delegate :client_rate_value, to: :task_level, allow_nil: true

  def to_s
    title
  end

  def owner?(user)
    self.owner_id == user.id
  end

  def assigned?(user)
    self.assignee_id == user.id
  end

  # подсчитанная внутренняя стоимость работ по задаче в любой момент времени
  def calculated_cost
    return unless self.hourly?
    self.estimated_time.to_s.to_d * self.task_level.rate_value.to_d
  end

  # подсчитанная внешняя (для клиента) стоимость работ по задаче в любой момент времени
  def calculated_client_cost
    return if !self.hourly? || self.client_rate_value.nil?
    self.estimated_time.to_s.to_d * self.task_level.client_rate_value.to_d
  end

  # сохраняем ставку в задачу
  def save_rate_cost
    return unless self.task_level.present?
    self.rate_cost = self.task_level.rate_value.to_d
    save
  end

  # сохраняем внешнюю ставку в задачу
  def save_client_rate_cost
    return unless self.task_level.present?
    self.client_rate_cost = self.task_level.client_rate_value.to_d
    save
  end

  # фиксируем внутреннюю стоимость работ в базе (вызывается при утверждении задачи)
  def save_estimated_cost
    return unless self.task_level.hourly?
    self.estimated_cost = self.estimated_time.to_s.to_d * self.rate_cost.to_s.to_d
    save
  end

  # фиксируем внешнюю (для клиента) стоимость работ в базе (вызывается при утверждении задачи)
  def save_estimated_client_cost
    return unless self.task_level.hourly?
    self.estimated_client_cost = self.estimated_time.to_s.to_d * self.client_rate_cost.to_s.to_d
    save
  end

  def hourly?
    self.task_level.present? && self.task_level.hourly?
  end

  def estimated?
    if self.hourly?
      self.estimated_time.present?
    else
      true
    end
  end

  def ready_for_approval?
    self.milestone.present? && self.estimated? && self.aim.present?
  end

  def rate
    if self.hourly?
      self.task_level.rate_value.to_d
    end
  end

  def user_invoice_summary
    "#{title} / #{estimated_time} / #{estimated_cost}"
  end

  def can_be_updated?
    !(["todo","current", "deferred", "resolved", "done"].include?(self.current_state))
  end

  private

  def self.transition_class
    TaskTransition
  end

  def self.initial_state
    TaskStateMachine.initial_state
  end

end
