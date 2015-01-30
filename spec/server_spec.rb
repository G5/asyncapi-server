require 'spec_helper'

module Asyncapi
  describe Server do

    describe ".expiry_threshold=" do
      let!(:original_expiry_threshold) { described_class.expiry_threshold }
      after { described_class.expiry_threshold = original_expiry_threshold }
      it "sets the threshold for expiring old jobs" do
        described_class.expiry_threshold = 2.days
        expect(described_class.expiry_threshold).to eq 2.days
      end
    end

    describe ".expiry_threshold" do
      it "defaults to 10 days" do
        expect(described_class.expiry_threshold).to eq 10.days
      end
    end

  end
end
