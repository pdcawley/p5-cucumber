use Test::Class::Sugar;

testclass TestRunner exercises Test::Cucumber::Runner {
    test loading {
        ok 1
    }
}


Test::Class->runtests unless caller();
