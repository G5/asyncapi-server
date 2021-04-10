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
        its(:params) { is_expected.to eq("{\"param\":\"values\"}") }

        context "status" do
          it "can also be assigned other values" do
            subject.status = :success
            subject.status = :error
            expect(subject.save).to eq(true)
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
