use MooseX::Declare;

class Test::Cucumber::Step {
    use Carp qw/croak/;
    
    has matcher => (is => 'ro', isa => 'RegexpRef');
    has handler => (is => 'ro', isa => 'CodeRef');

    method when (ClassName $class: Str|RegexpRef $matcher, CodeRef $handler) {
        $class->new(
            matcher => qr{^When ${matcher}$},
            handler => $handler,
        );
    }

    method matches ($line) {
        $line ~~ $self->matcher;
    }

    method run ($line) {
        my(@args) = $self->matches($line);
        croak "'$line' did not match qr{'", $self->matcher, "'" unless @args;
        $self->handler->(@args);
    }
    
}
