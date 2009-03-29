use MooseX::Declare;
use Test::Cucumber::Step;

class Test::Cucumber::StepCollection {
    use MooseX::AttributeHelpers;
    
    has step_defs => (
        metaclass => 'Collection::Array',
        is => 'rw',
        isa => 'ArrayRef[Test::Cucumber::Step]',
        default => sub {[]},
        auto_deref => 1,
        provides => {
            push => 'add',
            find => 'find',
        },
    );

    method matches ($line) {
        $self->find(sub { $_[0]->matches($line) })
    }

    method run ($line) {
        $self->matches($line)->run($line);
    }
}
