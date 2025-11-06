require "test_helper"

class WishlistMailerTest < ActionMailer::TestCase
  test "share_wishlist" do
    wishlist = Wishlist.first
    recipient_email = "to@example.org"
    mail = WishlistMailer.share_wishlist(wishlist, recipient_email)
    assert_equal "Share wishlist", mail.subject
    assert_equal [recipient_email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
