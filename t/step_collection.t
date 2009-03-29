use Test::Class::Sugar;

testclass TestStepCollection exercises Test::Cucumber::StepCollection {
    setup {
        my $set = $test->{set} = $test->subject->new();
        $set->add(Test::Cucumber::Step->then(qr/I (make) a step/, sub {ok 1}));
        $set->add(Test::Cucumber::Step->then(qr/I make a step/, sub {fail, "shouldn't be called"}));
        $set->add(Test::Cucumber::Step->then(qr/I do something different/, sub {ok 1}));
    }
    
    test matches I make a step {
        ok $test->{set}->matches('Then I make a step');
    }

    test run I make a step {
        $test->{set}->run('Then I make a step');
    }
}

Test::Class->runtests unless caller();
