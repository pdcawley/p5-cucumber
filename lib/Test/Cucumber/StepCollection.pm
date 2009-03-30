use MooseX::Declare;
use Test::Cucumber::Step;
use Test::Builder;

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

    method run ($line, $runstate) {
        Test::Builder->new->skip($line), return if $runstate->is_skipping;
        if (my $step = $self->matches($line)) {
            $step->run($line);
        }
        else {
            $runstate->start_skipping;
            Test::Builder->new->todo_skip($line);
        }
    }
}
