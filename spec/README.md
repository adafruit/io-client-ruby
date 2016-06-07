# Adafruit IO Ruby Client Test README

To run the tests you can use rake from the top level directory.

However, most tests require a valid Adafruit IO account to run, and so an
account key needs to be provided.  The key is passed to the tests via an
environment variable called ADAFRUIT_IO_KEY.

So, the tests can be run via the following command:

    ADAFRUIT_IO_KEY=my_key rake test

Alternatively, you can place the key into a file in the top level directory
called _.env_.  The format is the same as above, but as a single line and
by itself. e.g.

    # cat .env
    ADAFRUIT_IO_KEY=my_key

# NOTES

- Take care running the tests that you do not spam the server.  The server has
throttle checks in place and if you exceed the limit, you will be blocked for
a period of time. See
[HTTP 503: Unavailable](https://learn.adafruit.com/adafruit-io/http-status-codes).
See also [Data Policies](https://learn.adafruit.com/adafruit-io/data-policies).

- Additionally, you must have one feed, one group and one dashboard available
for creating. (As of this writing, you are allowed only 10, 10, and 5,
respectively). Again see
[Data Policies](https://learn.adafruit.com/adafruit-io/data-policies)
