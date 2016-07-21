# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Accept `expired_at` from the client in order to do our own cleaning (and not rely on getting delete requests)

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
