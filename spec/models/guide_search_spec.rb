# frozen_string_literal: true

require 'spec_helper'

describe GuideSearch do
  subject { GuideSearch.search }

  it 'defaults query to "*"' do
    expect(subject.query).to eq('*')
  end

  it 'searches for guides associated with crops' do
    crop = OpenStruct.new(id: 1)

    subject.for_crops(crop)

    expect(subject.filter[:crop_id]).to include(crop.id)
  end

  it 'searches for guides associated with crops by id' do
    crop = OpenStruct.new(id: 1)

    subject.for_crops(crop.id)

    expect(subject.filter[:crop_id]).to include(crop.id)
  end

  it 'searches without a user' do
    expect(subject.order).to eq(_score: :desc)
  end

  it 'knows if it is empty' do
    Guide.reindex
    subject.search('this will not return anything')

    expect(subject).to be_empty
  end

  it 'passes methods through to results' do
    expect { subject.first }.to_not raise_error
  end

  it 'raises no method error with method missing' do
    expect { subject.not_a_method }.to raise_error(NoMethodError)
  end
end
