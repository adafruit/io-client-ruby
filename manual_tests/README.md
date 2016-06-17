# Adafruit IO Ruby Manual Test README

To run the tests you can use rake from the top level directory.

However, these tests require a valid Adafruit IO account to run, and so an
account key needs to be provided.  The key is passed to the tests via an
environment variable called ADAFRUIT_IO_KEY.

## Ruby library based test

So, the base tests can be run via the following command:

    ADAFRUIT_IO_KEY=my_key rake iolib

Alternatively, you can place the key into a file in the top level directory
called _.env_.  The format is the same as above, but as a single line and
by itself. e.g.

    # cat .env
    ADAFRUIT_IO_KEY=my_key

The default tests run through the library code and provide essentially
100% code coverage. (There is currently an exception or two that need
addressing, but those are corner cases.  100% of the server functionality
is tested and covered.)

## Direct HTTP-based test

There is another test that can be run, which uses HTTP to access the server,
instead of the _io-client-ruby_ library.  This test can be run, for instance,
determine if a failure lies within the ruby library itself.

The HTTP tests can be run via the following rake command (assuming the key
is already specified somehow):

    rake http

Both tests run the exact same tests and verification and share much code - it
is only the mechanism of hitting the server that differs, so the HTTP-based
tests are a reliable way of verifying server changes.  And so, it can be used
periodically, or whenever there are server side changes to the API as well.


# NOTES

- Take care running the tests that you do not spam the server.  The server has
throttle checks in place and if you exceed the limit, you will be blocked for
a period of time. See
[HTTP 503: Unavailable](https://learn.adafruit.com/adafruit-io/http-status-codes).
See also [Data Policies](https://learn.adafruit.com/adafruit-io/data-policies).

- Additionally, you must have one feed and one group slot open for creation.
(As of this writing, you are allowed only 10 feeds and 10 groups).
Again see [Data Policies](https://learn.adafruit.com/adafruit-io/data-policies)
