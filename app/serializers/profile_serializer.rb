class ProfileSerializer < BaseSerializer

  def serialize
    {
      uid: object.uid,
      name: object.name,
      links: serialized_links
    }
  end

  private

  def serialized_links
    {
      organisation: organisation_link
    }
  end

  def organisation_link
    object.organisation ? "/api/v1/organisations/#{object.organisations.first.uid}" : nil
  end
end
