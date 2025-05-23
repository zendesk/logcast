## Logcast [![Build Status](https://travis-ci.org/zendesk/logcast.png)](https://travis-ci.org/zendesk/logcast)

Log Broadcaster with support for Rails >= v4.2

## Usage

### Rails

```ruby
require 'logcast/rails'

# mirror logging
Rails.logger.subscribe(Logger.new(STDERR)) # anything that responds to add or (write and close)

# capture logging
my_custom_stream = StringIO.new
Rails.logger.subscribe(my_custom_stream) do
  ... some evil stuff ...
end
logs = my_custom_stream.string
```

### Ruby

```ruby
require 'logcast'
require 'logger'
broadcaster = Logcast::Broadcaster.new
broadcaster.subscribe(Logger.new(STDERR))

broadcaster.info("Hi!")
```

## Testing

```
bundle exec appraisal install # install the deps
bundle exec appraisal rake # run the tests across each 'appraisal'
```

### Releasing a new version
A new version is published to RubyGems.org every time a change to `version.rb` is pushed to the `main` branch.
In short, follow these steps:
1. Update `version.rb`,
2. update version in all `Gemfile.lock` files,
3. merge this change into `main`, and
4. look at [the action](https://github.com/zendesk/logcast/actions/workflows/publish.yml) for output.

To create a pre-release from a non-main branch:
1. change the version in `version.rb` to something like `1.2.0.pre.1` or `2.0.0.beta.2`,
2. push this change to your branch,
3. go to [Actions → “Publish to RubyGems.org” on GitHub](https://github.com/zendesk/logcast/actions/workflows/publish.yml),
4. click the “Run workflow” button,
5. pick your branch from a dropdown.

## Copyright and license

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
