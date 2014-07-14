name "osuosl"
description "Role applied to all servers at OSUOSL"

default_attributes(
  :networking => {
    :nameservers => [ "8.8.8.8", "8.8.4.4" ],
    :roles => {
      :external => {
        :inet => {
          :prefix => "28",
          :gateway => "140.211.167.97"
        }
      },
      :external => {
        :zone => "ool"
      }
    }
  }
)

override_attributes(
  :ntp => {
    :servers => [ "ntp.osuosl.org" ]
  }
)

run_list(
  "role[us]"
)