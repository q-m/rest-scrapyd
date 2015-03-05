#
# Simple REST-client for the Scrapyd API
#
require 'rest-core'

RestScrapyd = RC::Builder.client do
  use RC::Timeout       , 3

  use RC::DefaultSite   , 'http://localhost:6800/'
  use RC::DefaultHeaders, {'Accept' => 'application/json'}
  use RC::AuthBasic     , nil, nil

  use RC::CommonLogger  , nil
  use RC::ErrorHandler  , lambda {|env| RuntimeError.new(env[RC::RESPONSE_BODY]['message']) }
  use RC::ErrorDetector , lambda {|env| env[RC::RESPONSE_BODY]['status'] != 'ok' rescue false }
  use RC::ErrorDetectorHttp
  use RC::JsonResponse  , true
  use RC::Cache         , nil, 600
end


# Don't define a `RestScrapyd::Client` and include it in the class to avoid yardoc choking
# (plus two newlines to avoid this getting into the documentation)


class RestScrapyd
  include RestCore

  # @!attribute project
  # Default project name (can also be passed as hash argument to constructor).
  attr_accessor :project

  # Add a version to a project, creating the project if it doesn’t exist.
  # @param version [String] Project version
  # @param egg [String, IO] Filename or file to upload, must be a Scrapy egg
  # @return [Hash<String, Object>] Response, right now just +{"spiders": <n>}+
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#addversion-json
  def addversion(version, egg, project=self.project)
    egg = File.open(egg, 'rb') if egg.is_a? String
    post('addversion.json', project: project, version: version, egg: egg)
  end

  # Schedule a spider run (also known as a job).
  # @param spider [String] Spider name
  # @param version [String] Project version
  # @param settings [Hash<String, String>] Additional Scrapy settings
  # @option settings [String] :project ({self.project}) Project name
  # @return [String] Job id
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#schedule-json
  def schedule(spider, version, settings={})
    settings = {project: self.project, spider: spider}.merge(settings)
    post('schedule.json', settings)['jobid']
  end

  # Cancel a scheduled or running job
  # @param job [String] Jobid to cancel
  # @param project [String] Project name
  # @return [String] Previous state of job
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#cancel-json
  def cancel(job, project=self.project)
    post('cancel.json', project: project, job: job)['prevstate']
  end

  # Get the list of projects uploaded to this Scrapy server.
  # @return [Array<String>] Available projects
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#listprojects-json
  def listprojects
    get('listprojects.json')['projects']
  end

  # Get the list of versions available for some project.
  # @param project [String] Project name
  # @return [Array<String>] Available versions for project
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#listversions-json
  def listversions(project=self.project)
    get('listversions.json', project: project)['versions']
  end

  # Get the list of spiders available in the last version of some project.
  # @param project [String] Project name
  # @return [Array<String>] Available spiders for project
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#listspiders-json
  def listspiders(project=self.project)
    get('listspiders.json', project: project)['spiders']
  end

  # Get the list of pending, running and finished jobs of some project.
  # @param project [String] Project name
  # @return [Hash<String, Array<Hash>>] Jobs for project
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#listjobs-json
  def listjobs(project=self.project)
    get('listjobs.json', project: project).reject{|k,v| k=='status'}
  end

  # Delete a project version.
  # @param version [String] Project version
  # @param project [String] Project name
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#delversion-json
  def delversion(version, project=self.project)
    post('delversion.json', project: project, version: version)
  end

  # Delete a project and all its uploaded versions.
  # @param project [String] Project name
  # @see http://scrapyd.readthedocs.org/en/latest/api.html#delproject-json
  def delproject(project)
    post('delproject.json', project: project)
  end
end
