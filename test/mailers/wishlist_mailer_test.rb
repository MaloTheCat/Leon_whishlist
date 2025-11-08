require "test_helper"

class WishlistMailerTest < ActionMailer::TestCase
  test "share_wishlist" do
    wishlist = wishlists(:one)
    recipient_email = "to@example.org"
    mail = WishlistMailer.share_wishlist(wishlist, recipient_email)
    assert_equal "John Doe partage sa liste de cadeaux avec vous !", mail.subject
    assert_equal [recipient_email], mail.to
    assert_match "John Doe", mail.body.encoded
  end
end
