#!/usr/bin/env ruby

##
# Data for TestObject class
#

TEST_FEED_NAME_1  = "feed xyzzy"
TEST_FEED_NAME_2  = "feed foobar"
TEST_GROUP_NAME_1 = "group xyzzy"
TEST_GROUP_NAME_2 = "group foobar"

TEST_FEED_NAMES  = [ TEST_FEED_NAME_1,  TEST_FEED_NAME_2  ]
TEST_GROUP_NAMES = [ TEST_GROUP_NAME_1, TEST_GROUP_NAME_2 ]

##
# Hash of hashes, each containing information for the API ops with a payload,
#  including the (parts of the) payload to send.
#
LIST_OF_PROP_SETS = {
  feeds: {
    name: "feeds",
    path: "feeds",
    ctor: ->(ps) { TestObject.new(ps) } ,
    create: {
        "name"          => TEST_FEED_NAME_1,
        "description"   => "feed Xyyzy Foobar",
    },
    update: {
        "description"   => "feed Foobar Xyyzy",
    },
    replace: {
        "name"          => TEST_FEED_NAME_2,
        "description"   => "Xyyzy Foobar feed",
    },
  },

  groups: {
    name: "groups",
    path: "groups",
    ctor: ->(ps) { TestObject.new(ps) } ,
    create: {
        "name"          => TEST_GROUP_NAME_1,
        "description"   => "group Xyyzy Foobar",
    },
    update: {
        "description"   => "group Foobar Xyyzy",
    },
    replace: {
        "name"          => TEST_GROUP_NAME_2,
        "description"   => "Xyyzy Foobar group",
    },
  },

  data: {
    name: "data",
    path: "feeds/_FEEDID_/data",      # _FEEDID_ replaced with actual feed id
    ctor: ->(ps) { TestDataObject.new(ps) } ,
    create: {
        "value" => "data xyzzy",
    },
    update: {
        "value" => "data foobar",
    },
    replace: {
        "value" => "xyyzy data",
    },
  },
}
