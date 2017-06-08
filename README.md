# dbs_sgd_inr_remit_alert

SGD to INR remittance alert is the ruby based app which checks on the DBS current conversion rates for INR and prompts a alert based on ceiling amount you have set for yourself when you would transfer.


## Supports
 * MacOS

 * Linux (Future)

 * Debian (Future)


## Pre-requisites
* [Install git](https://git-scm.com/downloads).

* Install recent version of [Ruby](https://www.ruby-lang.org/en/downloads/)

## Simple installation

Clone the dbs_sgd_inr_remit_alert repo:

```bash

git clone https://github.com/mrigeshpriyadarshi/dbs_sgd_inr_remit_alert.git
cd dbs_sgd_inr_remit_alert

```

And then, Execute the one-time pre-requisities setup script [install_prereqs.sh](bin/install_prereqs.sh)

```bash

sh bin/install_prereqs.sh

```

Then execute [start_alert.sh](bin/start_alert.sh) for setting up the alert.

```bash

sh bin/start_alert.sh

```


## Contribute

1. Fork it
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create new Pull Request


## License

|  |  |
| ------ | --- |
| **Author:** | Mrigesh Priyadarshi |
| **Copyright:** | [Mrigesh Priyadarshi](mailto:mrigeshpriyadarshi@gmail.com) |
| **License:** | Apache License, Version 2.0 |

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

See [LICENSE](license) for more information.