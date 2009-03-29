use Test::Class::Sugar;

testclass StringStep exercises Test::Cucumber::Step {
    setup {
        $test->{step} = $test->subject->then(qr/I make a step/, sub {ok 1});
    }
    
    test matches {
        ok $test->{step}->matches('Then I make a step');
    }

    test run {
        $test->{step}->run('Then I make a step');
    }
}

testclass RegexStep exercises Test::Cucumber::Step {
    setup {
        $test->{step} = $test->subject->then(qr/I (\w+) a step/, sub { is $_[1], 'make' })
    }

    test matching >> 2 {
        my $step = $test->{step};
        ok $step->matches('Then I make a step');
        ok ! $step->matches('Then I make a misstep');
    }
}
                            

Test::Class->runtests unless caller();
