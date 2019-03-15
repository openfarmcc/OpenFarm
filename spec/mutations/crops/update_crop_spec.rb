require "spec_helper"
require "openfarm_errors"

describe Crops::UpdateCrop do
  let(:mutation) { Crops::UpdateCrop }

  let(:user) { FactoryBot.create(:user) }
  let(:crop) { FactoryBot.create(:crop) }
  let(:companion_crop) { FactoryBot.create(:crop) }

  let(:params) do
    { user: user,
      id: "#{crop.id}",
      attributes: { binomial_name: "updated",
                    description: "A random description" } }
  end

  it "requires fields" do
    errors = mutation.run({}).errors.message_list
    expect(errors).to include("Attributes is required")
    expect(errors).to include("ID is required")
  end

  it "updates valid crops" do
    result = mutation.run(params).result
    expect(result).to be_a(Crop)
    expect(result.valid?).to be(true)
  end

  it "updates a crop taxon" do
    params[:attributes][:taxon] = "Genus"
    result = mutation.run(params).result
    expect(result).to be_a(Crop)
    expect(result.valid?).to be(true)
    expect(result.taxon).to eq("Genus")
  end

  it "updates crop companions" do
    params[:attributes][:companions] = [companion_crop].map(&:id)
    result = mutation.run(params).result
    expect(result).to be_a(Crop)
    expect(result.valid?).to be(true)
    expect(result.companions.first).to eq(companion_crop)
  end

  it "disallows phony URLs" do
    image_hash = {
      image_url: "iWroteThisWrong.net/2haLt4J.jpg",
    }
    image_params = params.merge(images: [image_hash])
    results = mutation.run(image_params)
    expect(results.success?).to be_falsey
    expect(results.errors.message[:images]).to include("not a valid URL")
  end
end
