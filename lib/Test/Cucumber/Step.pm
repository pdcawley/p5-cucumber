use MooseX::Declare;

class Test::Cucumber::Step {
    use Carp qw/croak/;
    
    has matcher => (is => 'ro', isa => 'RegexpRef');
    has handler => (is => 'ro', isa => 'CodeRef');
    has plan    => (is => 'ro', isa => 'Int');

    method then (ClassName $class: Str|RegexpRef $matcher, CodeRef $handler, $plan = 1) {
        $class->new(
            matcher => qr{^Then ${matcher}$},
            handler => $handler,
            plan    => $plan,
        );
    }

    method matches ($line) {
        $line =~$self->matcher;
    }

    method run ($line) {
        my(@args) = $self->matches($line);
        croak "'$line' did not match qr{'", $self->matcher, "'" unless @args;
        $self->handler->(@args);
    }
}
