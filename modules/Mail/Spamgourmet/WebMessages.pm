package Mail::Spamgourmet::WebMessages;
use strict;
use Mail::Spamgourmet::Page;

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = {};
  bless $self,$class;
  my %params = @_;
  if ($params{'config'}) {
    $self->{'config'} = $params{'config'};
    $self->{'mailer'} = $params{'config'}->getMailer();
  } else {
    die 'WebMessages must be initialized with an instance of Mail::Spamgourmet::Config.pm';
  }
  return $self;
}


sub sendpasswordresetmessage {
  my $self = shift;
  my $session = shift;
  my $thisscript = shift;
  my $newaddress = shift;
  my $hashcode = shift;
  my $subject = $session->getDialog('setnewpassword');
  my $url = "\nhttp://www.spamgourmet.com/$thisscript?resetpassword=1&hc=$hashcode";

  my $body = Mail::Spamgourmet::Page->new(template=>'resetpasswordmessage.txt',
                                          languageCode=>$session->getLanguageCode());

  $body->setTags('url',$url,'username',$session->{'UserName'});
  my $msg = "From: " . $self->getConfig()->getAdminEmail() . "\n";
  $msg .= "Subject: $subject\nMIME-Version: 1.0\nContent-Type: text/plain; charset=\"utf-8\"\n";
  $msg .= $body->getContent();
  $self->{'mailer'}->sendMail(\$msg, $newaddress, $self->getConfig()->getAdminEmail());
#  $self->{'config'}->debug("sent password reset message");
}



sub sendconfirmationmessage {
  my $self = shift;
  my $session = shift;
  my $thisscript = shift;
  my $newaddress = shift;
  my $hashcode = shift;
  my $subject = $session->getDialog('addressconfirmation');
  my $url = "\nhttp://www.spamgourmet.com/$thisscript?cec=$hashcode";

  my $body =Mail::Spamgourmet::Page->new(template=>'confirmationmessage.txt',
   languageCode=>$session->getLanguageCode());

  $body->setTags('url',$url,'newaddress',$newaddress);
  my $msg = "From: " . $self->getConfig()->getAdminEmail() . "\n";
  $msg .= "Subject: $subject\nMIME-Version: 1.0\nContent-Type: text/plain; charset=\"utf-8\"\n";
  $msg .= $body->getContent();
  $self->{'mailer'}->sendMail(\$msg, $newaddress, $self->getConfig()->getAdminEmail());
}

sub getConfig {
  my $self = shift;
  return $self->{'config'};
}


1;