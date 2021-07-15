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

## Copyright and license

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
