use Test::Class::Sugar;
use Test::Cucumber::Runner::State;

testclass TestStepCollection exercises Test::Cucumber::StepCollection uses -Tester, -Most {
    setup {
        my $set = $test->{set} = $test->subject->new();
        $test->{runstate} = Test::Cucumber::Runner::State->new();
        $set->add(Test::Cucumber::Step->then(qr/I (make) a step/, sub {ok 1}));
        $set->add(Test::Cucumber::Step->then(qr/I make a step/, sub {fail "shouldn't be called"}));
        $set->add(Test::Cucumber::Step->then(qr/I do something different/, sub {ok 1}));
        $set->add(Test::Cucumber::Step->then(qr/I should be skipped/, sub { fail "I should be skipped" }));
    }
    
    test matches I make a step {
        ok $test->{set}->matches('Then I make a step');
    }

    test run I make a step {
        $test->{set}->run('Then I make a step', $test->runstate);
    }

    test missing test does todo_skip and marks the runstate with is_skipping >> 9 {
        check_test(
            sub { $test->{set}->run('Then it fails to exist', $test->runstate) },
            {
                ok => 1,
                actual_ok => 0,
                type => 'todo_skip',
                reason => 'Then it fails to exist',
            }
        );
        ok $test->runstate->is_skipping;
    }

    test skips existing tests if the runstate is skipping >> 6 {
        $test->runstate->start_skipping;
        check_test(
            sub { $test->{set}->run('Then I make a step', $test->runstate) },
            {
                type => 'skip',
                reason => 'Then I make a step',
            }
        );
    }

    test missing test does a simple skip if the runstate is already skipping >> 6 {
        $test->runstate->start_skipping;
        check_test(
            sub { $test->{set}->run('Then it fails to exist', $test->runstate) },
            {
                type => 'skip',
                reason => 'Then it fails to exist',
            }
        );
    }

    sub runstate {
        $_[0]->{runstate}
    }
}

Test::Class->runtests unless caller();
