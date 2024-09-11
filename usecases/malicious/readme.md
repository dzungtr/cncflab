# Malicious test


### Install flightsim


```shell
go install github.com/alphasoc/flightsim/v2@latest
```


### Running flightslim

```
$ flightsim --help

AlphaSOC Network Flight Simulator™ (https://github.com/alphasoc/flightsim)

flightsim is an application which generates malicious network traffic for security
teams to evaluate security controls (e.g. firewalls) and ensure that monitoring tools
are able to detect malicious traffic.

Usage:
    flightsim <command> [arguments]

Available commands:
    get         Get a list of elements (ie. families) of a certain category (ie. c2)
    run         Run all modules, or a particular module
    version     Prints the version number

Cheatsheet:
    flightsim run                   Run all the modules
    flightsim run c2                Simulate C2 traffic
    flightsim run c2:trickbot       Simulate C2 traffic for the TrickBot family
    flightsim run ssh-transfer:1GB  Simulate a 1GB SSH/SFTP file transfer

    flightsim get families:c2       Get a list of all c2 families
```

More detail usage can be reference to https://github.com/alphasoc/flightsim