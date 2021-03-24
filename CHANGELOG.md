# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.3.0] - 2021-03-24
### Added [#14](http://github.com/G5/asyncapi-server/pull/10)
- Decouple job status notification from JobWorker

## [1.2.0] - 2019-05-29
### Added [#10](http://github.com/G5/asyncapi-server/pull/10)
- Make gem Rails 5 compatible
- Change `asyncapi_post` usage - use kwargs on params

  On your Rails 5 application, use `asyncapi_post(url, params: params)` instead of `asyncapi_post(url, params)`

## [1.1.3] - 2016-08-30
### Fixed
- Allow retry in case of AR-Sidekiq race condition

## [1.1.2] - 2016-07-22
### Fixed
- Relax responders version

## [1.1.1] - 2016-07-21
### Fixed
- Sidekiq sometimes not able to find Job records

## [1.1.0] - 2016-03-21
### Added
- Re-raise error if job worker runs into one. Makes errors more visible.

## [1.0.0]
### Fixed
- Fix issue with asyncapi client not seeing request body; post as json
- Send secret back to the app using `asyncapi-client` for authentication

### Added
- Periodically clean up old jobs (migrations must be installed again)
- Add RSpec helper for request specs to post asyncapi jobs

## [0.0.1]
### Added
- Initial working version
