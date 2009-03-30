use Test::Class::Sugar;

testclass TestRunstate exercises Test::Cucumber::Runner::State {
    test initial state should not be skipping {
        ok !$test->instance->is_skipping;
    }

    test start_skipping should set the state to true {
        $test->instance->start_skipping;
        ok $test->instance->is_skipping;
    }
    
    sub instance {
        $_[0]->{instance} ||= $_[0]->subject->new;
    }
}


Test::Class->runtests unless caller();
