shared_context "create 3 tasks" do
  before do
    @project = FactoryGirl.create(:sample_project,
                                  organization: @organization,
                                  team: @team
                                 )
    @milestone = FactoryGirl.create(:sample_milestone,
                                    organization: @organization,
                                    project: @project
                                   )

    @task_level_tech = FactoryGirl.create(:task_level_tech, organization: @organization)

    @team_lead = @member_3
    @task_1 = create_task_for @member_1, @team_lead
    @task_2 = create_task_for @member_2, @team_lead
    @task_3 = create_task_for @member_3, @team_lead
  end
end

shared_context "create and accept 3 tasks" do
  include_context "create 3 tasks"

  before do
    milestone_start @milestone

    accept_task @task_1, @team_lead
    accept_task @task_2, @team_lead
    accept_task @task_3, @team_lead
  end
end
