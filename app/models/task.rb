class Task < ActiveRecord::Base
  resourcify
  include Authority::Abilities
  include Statesman::Adapters::ActiveRecordQueries

  self.authorizer_name = 'TaskAuthorizer'

  # TODO remove :status from code and db

  validates :title, :organization, presence: true
  validates :estimated_time, numericality: { less_than_or_equal_to: 8 }

  belongs_to :milestone
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :task_level
  belongs_to :organization
  belongs_to :user_invoice

  has_many :task_transitions, dependent: :destroy

  scope :ordered_by_id, -> { order("id asc") }
  scope :by_organization, -> (id) { where(:organization_id => id) }
  scope :user_uninvoiced, -> {where(:user_invoice_id => nil)}
  scope :user_invoiced, -> {where('user_invoice_id is not null')}

  # join(:project=>[:owner])
  #scope :by_team, -> (id) {joins(:milestone => [:project]).where('milestone.project.team_id = ?', id) }

  def state_machine
     @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state, :trigger!, :available_events,
           to: :state_machine

  delegate :team, to: :milestone, allow_nil: true
  delegate :project, to: :milestone, allow_nil: true
  delegate :rate_value, to: :task_level, allow_nil: true
  delegate :client_rate_value, to: :task_level, allow_nil: true

  def to_s
    title
  end

  def team
    if milestone.present? && milestone.team.present?
      milestone.team
    end
  end

  # подсчитанная внутренняя стоимость работ по задаче в любой момент времени
  def calculated_cost
    return unless self.hourly?
    self.estimated_time.to_s.to_d * self.task_level.rate_value.to_s.to_d
  end

  # подсчитанная внешняя (для клиента) стоимость работ по задаче в любой момент времени
  def calculated_client_cost
    return if !self.hourly? || self.client_rate_value.nil?
    self.estimated_time.to_s.to_d * self.task_level.client_rate_value.to_s.to_d
  end

  # сохраняем ставку в задачу
  def save_rate_cost
    return unless self.task_level.present?
    self.rate_cost = self.task_level.rate_value
    save
  end

  # сохраняем внешнюю ставку в задачу
  def save_client_rate_cost
    return unless self.task_level.present?
    self.client_rate_cost = self.task_level.client_rate_value
    save
  end

  # фиксируем внутреннюю стоимость работ в базе (вызывается при утверждении задачи)
  def save_estimated_cost
    return unless self.task_level.hourly?
    self.estimated_cost = self.calculated_cost
    save
  end

  # фиксируем внешнюю (для клиента) стоимость работ в базе (вызывается при утверждении задачи)
  def save_estimated_client_cost
    return unless self.task_level.hourly?
    self.estimated_client_cost = self.calculated_client_cost
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
      self.task_level.rate_value
    end
  end

  def can_be_updated?
    ["current", "deferred", "resolved", "done"].include?(self.current_state)
  end

  def user_invoice_summary
    "#{title} / #{estimated_time} / #{estimated_cost}"
  end

  private

  def self.transition_class
    TaskTransition
  end

  def self.initial_state
    TaskStateMachine.initial_state
  end

end
