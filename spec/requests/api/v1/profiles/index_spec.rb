require "rails_helper"

RSpec.describe "GET /api/v1/profiles" do
  it_behaves_like "a protected endpoint", "/api/v1/profiles"

  context "with a valid authentication token" do
    include_context "logged in API User"

    context "with no filtering parameters" do
      it "returns a 200 response with all profiles in name order" do
        organisation    = create :organisation
        users_profile   = profile.tap {|p| p.update name: "Eamonn Holmes", organisations: [organisation] }
        another_profile = create :profile, name: "Barry Evans", organisations: [organisation]

        get "/api/v1/profiles", nil, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => another_profile.uid,
              "name" => "Barry Evans",
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.uid}"
              }
            },
            {
              "uid" => users_profile.uid,
              "name" => "Eamonn Holmes",
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.uid}"
              }
            }
          ]
        )
      end
    end

    context "with a UID filter" do
      it "returns a 200 response with only matching profiles" do
        organisation     = create :organisation
        matching_profile = profile.tap {|p| p.update organisations: [organisation] }
                           create :profile, organisations: [organisation]

        get "/api/v1/profiles", { uids: [matching_profile.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => matching_profile.uid,
              "name" => matching_profile.name,
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.uid}"
              }
            }
          ]
        )
      end

      it "returns a 200 with many matching profiles if provided with many UIDs, in name order" do
        organisation = create :organisation
        match_1      = profile.tap {|p| p.update name: "Barry Scott", organisations: [organisation] }
        match_2      = create :profile, name: "Barry Evans", organisations: [organisation]
                       create :profile, organisations: [organisation]

        get "/api/v1/profiles", { uids: [match_1.uid, match_2.uid] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => [
            {
              "uid" => match_2.uid,
              "name" => "Barry Evans",
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.uid}"
              }
            },
            {
              "uid" => match_1.uid,
              "name" => "Barry Scott",
              "links" => {
                "organisation" => "/api/v1/organisations/#{organisation.uid}"
              }
            }
          ]
        )
      end

      it "returns an empty 200 response if no profiles match" do
        organisation = create :organisation
                       create :profile, organisations: [organisation]

        get "/api/v1/profiles", { uids: ["doesn't-exist"] }, api_request_headers

        expect(response.status).to eq(200)
        expect(response_json).to eq(
          "profiles" => []
        )
      end
    end
  end
end
