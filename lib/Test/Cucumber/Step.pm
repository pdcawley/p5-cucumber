use MooseX::Declare;

class Test::Cucumber::Step {
    use Carp qw/croak/;
    use Test::More;
    
    has matcher => (is => 'ro', isa => 'RegexpRef');
    has handler => (is => 'ro', isa => 'CodeRef');
    has plan    => (is => 'ro', isa => 'Int');

    method given (ClassName $class: Str|RegexpRef $matcher, CodeRef $handler) {
        $class->new(
            matcher => qr{^Given ${matcher}$},
            handler => sub {
                $handler->(@_);
                ok 1;
            },
            plan => 1,
        );
    }

    method when (ClassName $class: Str|RegexpRef $matcher, CodeRef $handler) {
        $class->new(
            matcher => qr{^When ${matcher}$},
            handler => sub {
                $handler->(@_);
                ok 1;
            },
            plan => 1,
        );
    }
    
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
