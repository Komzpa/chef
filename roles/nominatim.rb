name "nominatim"
description "Role applied to all nominatim servers"

default_attributes(
  :accounts => {
    :users => {
      :lonvia => { :status => :administrator },
      :twain => { :status => :administrator },
      :nominatim => {
        :status => :role,
        :members => [:lonvia, :tomh, :twain]
      }
    }
  },
  :apache => {
    :mpm => "event",
    :timeout => 60,
    :keepalive => false,
    :event => {
      :server_limit => 32,
      :max_clients => 1600,
      :threads_per_child => 50
    }
  },
  :postgresql => {
    :settings => {
      :defaults => {
        :max_connections => "450",
        :synchronous_commit => "off",
        :checkpoint_segments => "32",
        :checkpoint_timeout => "10min",
        :max_wal_size => "1536MB",
        :checkpoint_completion_target => "0.9",
        :shared_buffers => "2GB",
        :autovacuum_max_workers => "1"
      }
    }
  },
  :sysctl => {
    :postgres => {
      :comment => "Increase shared memory for postgres",
      :parameters => {
        "kernel.shmmax" => 26 * 1024 * 1024 * 1024,
        "kernel.shmall" => 26 * 1024 * 1024 * 1024 / 4096
      }
    },
    :kernel_scheduler_tune => {
      :comment => "Tune kernel scheduler preempt",
      :parameters => {
        "kernel.sched_min_granularity_ns" => 10000000,
        "kernel.sched_wakeup_granularity_ns" => 15000000
      }
    },
    :swappiness => {
      :comment => "Reduce swap usage",
      :parameters => {
        "vm.swappiness" => 10
      }
    },
    :network_conntrack_time_wait => {
      :comment => "Only track completed connections for 30 seconds",
      :parameters => {
        "net.netfilter.nf_conntrack_tcp_timeout_time_wait" => "30"
      }
    },
    :network_conntrack_max => {
      :comment => "Increase max number of connections tracked",
      :parameters => {
        "net.netfilter.nf_conntrack_max" => "131072"
      }
    }
  },
  :nominatim => {
    :enabled => false,
    :repository => "git://git.openstreetmap.org/nominatim.git",
    :tablespaces => {
      "Osm2pgsql_Data" => "data",
      "Osm2pgsql_Index" => "data",
      "Place_Data" => "data",
      "Place_Index" => "ssd2",
      "Address_Data" => "data",
      "Address_Index" => "ssd2",
      "Search_Data" => "ssd1",
      "Search_Index" => "ssd1",
      "Aux_Data" => "aux",
      "Aux_Index" => "aux"
    },
    :fpm_pools => {
      :www => {
        :port => "8000",
        :pm => "dynamic",
        :max_children => "60"
      },
      :bulk => {
        :port => "8001",
        :pm => "static",
        :max_children => "10"
      },
      :details => {
        :port => "8002",
        :pm => "static",
        :max_children => "2"
      }
    },
    :redirects => {}
  }
)
