use MooseX::Declare;

class Test::Cucumber::Runner::State {
    has is_skipping => (
        is => 'rw',
        isa => 'Bool',
        default => 0,
    );

    method start_skipping {
        $self->is_skipping(1);
    }
}
