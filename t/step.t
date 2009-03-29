use Test::Class::Sugar;

testclass exercises Test::Cucumber::Step {
    setup {
        $test->{step} = $test->subject->when(qr/I make a step/, sub {ok 1});
    }
    
    test construction {
        ok $test->{step}->matches('When I make a step');
    }

    test runstep {
        $test->{step}->run('When I make a step');
    }
}

Test::Class->runtests unless caller();
