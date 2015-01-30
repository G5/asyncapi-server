require "spec_helper"

module Asyncapi
  module Server
    describe Job do
      it "has a table name of `asyncapi_server_jobs`" do
        expect(described_class.table_name).to eq "asyncapi_server_jobs"
      end

      describe "initialization" do
        subject do
          described_class.new(
            status: :queued,
            callback_url: 'http://callback_url.com',
            class_name: 'CreateStorageFacility',
            params: {param: 'values'}.to_json,
          )
        end

        its(:status) { is_expected.to eq "queued" }
        its(:callback_url) { is_expected.to eq "http://callback_url.com" }
        its(:class_name) { is_expected.to eq "CreateStorageFacility" }
        its(:params) { is_expected.to eq({param: "values"}.to_json) }

        context "status" do
          it "can also be assigned other values" do
            subject.status = :success
            subject.status = :error
            expect(subject.save).to eq(true)
          end
        end
      end

      describe "before creation" do
        describe "#expired_at" do
          it "is set to the Asyncapi::Server.expiry_threshold time from now" do
            Timecop.freeze
            job = create(:asyncapi_server_job)
            expect(job.expired_at).
              to eq Asyncapi::Server.expiry_threshold.from_now
          end

          context "#expired_at is already set" do
            it "does not override it" do
              job = create(:asyncapi_server_job, expired_at: 1.minute.from_now)
              expect(job.expired_at).to eq 1.minute.from_now
            end
          end

          context "setting is nil" do
            let!(:original_expiry_threshold) { Server.expiry_threshold }
            before { Server.expiry_threshold = nil }
            after { Server.expiry_threshold = original_expiry_threshold }

            it "does not set the expired_at" do
              job = create(:asyncapi_server_job)
              expect(job.expired_at).to be_nil
            end
          end
        end
      end

      describe "#url" do
        let(:job) { build_stubbed(:asyncapi_server_job) }
        it "is a url to the job" do
          expected_url = "http://test.com/asyncapi/server/v1/jobs/#{job.id}"
          expect(job.url).to eq expected_url
        end
      end

    end
  end
end
