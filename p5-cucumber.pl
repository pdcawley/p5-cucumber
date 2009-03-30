#!/usr/bin/env perl
=head1 Example of Perl Cucumber
=cut
use warnings;
use strict;
use lib 'lib';
use Test::More 'no_plan';
use Test::Cucumber::StepCollection;
use Test::Cucumber::Step;
use Test::Cucumber::Runner::State;

use Test::Cucumber::Parser;

my $story = <<EOF
Feature: Dealing with mushrooms
  In order to test the effect of evil poisonous mushrooms
  As an evil scientist
  I want to test effects of eating mushrooms on little children

  \@fufu \@version-4.15
  Scenario: Mushrooms are bad for you, they kill boys
    Given a live boy in a forest
    And his loyal dog
    When he ate a mushroom
    Then he was a dead boy in a forest

  Scenario: Mushrooms are bad for girls too
    Given a live girl in a forest
    When she ate a mushroom
    Then she was a dead girl in a forest
EOF
;

# empty hash to hold match strings/regexp and
# anonymous functions created by Given/When/Then
my $step_definitions = Test::Cucumber::StepCollection->new;

sub execute_match {
  my($line, $state) = @_;
  # match regexps in %matchers against subgroups
  # and call the callback function

  $step_definitions->run($line, $state);
}

# creator of matchers, commonly known as StoreMatcher
# but abbreviated into just 'sm'

sub sm {
  $step_definitions->add(shift)
}
sub Given($;&) {
  if (ref($_[0]) eq "Regexp")  {
      sm(Test::Cucumber::Step->given(@_))
  } else {
    execute_match("Given ".$_[0]);
  }
}
sub When($;&) {
  if (ref($_[0]) eq "Regexp") {
      sm(Test::Cucumber::Step->when(@_));
  } else {
    execute_match("When ".$_[0]);
  }
}
sub Then($;&) {
  if (ref($_[0]) eq "Regexp") {
      sm(Test::Cucumber::Step->then(@_));
  } else {
    execute_match("Then ".$_[0]);
  }
}

#
# hash to store variables that need to remember
# their state across the Given/When/Then scenarios
#
my %state;
#
# the code behind the story
#
Given qr/(.*) in (.*)/, sub {
    my ($description,$location) = @_;
    $state{human} = $description;
    $state{location} = $location;
};

When qr/s?he ate (.*)/, sub {
    my $item = shift;
    if ($item eq 'a mushroom') {
        $state{human} =~ s/live/dead/;
    }
};

Then qr/was (.*)/, sub {
    my ($description) = @_;
    is($state{human},$description,$description);
};

Then qr/in (.*)/, sub {
    my ($location) = @_;
    is($state{location},$location,$location);
};

Then qr/s?he was (.*) in (.*)/, sub {
    my ($description,$location) = @_;
    Then "was $description";
    Then "in $location";
};

#
# THE engine!
#


my $parser = Test::Cucumber::Parser->new();
my ($result,$tree) = $parser->parse($story);

for my $feature ($tree->features) {
	print "Feature: ",$feature->name,"\n";
	print $feature->header;
	for my $scenario ($feature->scenarios) {
        my $runstate = Test::Cucumber::Runner::State->new;
		print "\n";
		print "  Tags: ",join(',',$scenario->tags),"\n";
		print "  Scenario: ",$scenario->name,"\n";
		for my $step ($scenario->steps) {
			print "    $step\n";
			execute_match($step, $runstate);
		}
	}
}
