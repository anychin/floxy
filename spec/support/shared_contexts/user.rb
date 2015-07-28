shared_context "create owner and 3 members in team" do
  before do
    @owner = FactoryGirl.create(:user_with_organization_membership_owner,
                                email: "mail@email.com"
                               )
    @member_1 = FactoryGirl.create(:user_with_organization_membership_member,
                                   email: "mail_1@email.com"
                                  )
    @member_2 = FactoryGirl.create(:user_with_organization_membership_member,
                                   email: "mail_2@email.com"
                                  )
    @member_3 = FactoryGirl.create(:user_with_organization_membership_member,
                                   email: "mail_3@email.com"
                                  )
    @organization = @owner.organization_memberships.first.organization
    @team = FactoryGirl.create(:sample_team, organization_id: @organization.id)

    @tm_owner = FactoryGirl.create(:team_membership, user: @owner, team: @team)
    @tm_1 = FactoryGirl.create(:team_membership, user: @member_1, team: @team)
    @tm_2 = FactoryGirl.create(:team_membership, user: @member_2, team: @team)
    @tm_3 = FactoryGirl.create(:team_membership_team_lead, user: @member_3, team: @team)
  end
end
