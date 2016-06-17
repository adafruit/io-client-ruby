$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# There's only 10 feeds/groups allowed and so limiting testing to one.
FEED_NAME1 = 'test_feed_1'.freeze
FEED_DESC = 'My Test Feed Description'.freeze

DATA_NAME1 = 'test_data_1'.freeze
DATA_NAME2 = 'test_data_2'.freeze

GROUP_NAME1 = 'test_group_1'.freeze
GROUP_NAME2 = 'test_group_2'.freeze
