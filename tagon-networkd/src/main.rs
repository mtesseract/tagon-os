use slog::o;
use slog_async;
use slog_scope::info;
use slog_term;

use slog::Drain;

fn main() {
    let decorator = slog_term::TermDecorator::new().build();
    let drain = slog_term::FullFormat::new(decorator).build().fuse();
    let drain = slog_async::Async::new(drain).build().fuse();

    let log = slog::Logger::root(drain, o!());
    let _guard = slog_scope::set_global_logger(log);

    slog_scope::scope(&slog_scope::logger().new(o!()), || run());
}

fn run() {
    info!("Starting tagon-auto-updater");
}
