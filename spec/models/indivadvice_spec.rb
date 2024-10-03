require 'spec_helper'

describe Indivadvice do
  before(:all) do
    @indivadvice = Indivadvice.make!
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(@indivadvice).to be_valid
    end

    it 'is not valid without indivadvicetarget_id' do
      @indivadvice.indivadvicetarget_id = nil
      expect(@indivadvice).not_to be_valid
    end

    it 'is not valid without indivname' do
      @indivadvice.indivname = nil
      expect(@indivadvice).not_to be_valid
    end

    it 'is not valid without startyear' do
      @indivadvice.startyear = nil
      expect(@indivadvice).not_to be_valid
    end

    it 'is not valid without hours' do
      @indivadvice.hours = nil
      expect(@indivadvice).not_to be_valid
    end

    it 'is not valid if indivadvicetarget_id is not a number' do
      @indivadvice.indivadvicetarget_id = 'not_a_number'
      expect(@indivadvice).not_to be_valid
    end
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:indivuser) }
  end
end
