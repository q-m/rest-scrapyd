
require 'rest-scrapyd'
require 'rest-core/test'

Pork::API.describe RestScrapyd do
  after do
    WebMock.reset!
  end

  def new
    RestScrapyd.new(project: 'default')
  end

  would 'schedule' do
    stub_request(:post, 'http://localhost:6800/schedule.json').
      to_return(:body => '{"status": "ok", "jobid": "1234Q"}')
    new.schedule('spider', 'version').should.eq("1234Q")
  end

  would 'cancel' do
    stub_request(:post, 'http://localhost:6800/cancel.json').
      to_return(:body => '{"status": "ok", "prevstate": "running"}')
    new.cancel('4321Q').should.eq("running")
  end

  would 'listprojects' do
    stub_request(:get, 'http://localhost:6800/listprojects.json').
      to_return(:body => '{"status": "ok", "projects": ["myproject", "otherproject"]}')
    new.listprojects.should.eq(["myproject", "otherproject"])
  end

  would 'listversions' do
    stub_request(:get, 'http://localhost:6800/listversions.json?project=default').
      to_return(:body => '{"status": "ok", "versions": ["r5", "r1"]}')
    new.listversions.should.eq(["r5", "r1"])
  end

  would 'listspiders' do
    stub_request(:get, 'http://localhost:6800/listspiders.json?project=default').
      to_return(:body => '{"status": "ok", "spiders": ["spider1", "spider2", "spider3"]}')
    new.listspiders.should.eq(["spider1", "spider2", "spider3"])
  end

  would 'listjobs' do
    stub_request(:get, 'http://localhost:6800/listjobs.json?project=default').
      to_return(:body => '{"status": "ok",
       "pending": [{"id": "12A", "spider": "spider1"}],
       "running": [{"id": "12B", "spider": "spider2", "start_time": "2012-09-12 10:14:03.594664"}],
       "finished": [{"id": "12C", "spider": "spider3", "start_time": "2012-09-12 10:14:03.594664", "end_time": "2012-09-12 10:24:03.594664"}]}')
    new.listjobs.keys.should.eq(["pending", "running", "finished"])
  end

  would 'error code' do
    stub_request(:get, 'http://localhost:6800/listprojects.json').
      to_return(:body => '{"status": "error", "message": "whoops"}')
    lambda { new.listprojects }.should.raise(RuntimeError)
  end

end
