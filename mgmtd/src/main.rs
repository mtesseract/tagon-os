use slog::o;
use slog_async;
use slog_scope::{error, info};
use slog_term;

use serde::Deserialize;
use slog::Drain;

use envy;
#[derive(Deserialize, Debug)]
struct Config {
    #[serde(default = "default_image_repo")]
    image_repo: String,
}

fn default_image_repo() -> String {
    IMAGE_REPO.to_string()
}

const IMAGE_REPO: &str = "github.com/mtesseract/tagon-os";
const VERSION: Option<&'static str> = option_env!("VERSION");

fn main() {
    let decorator = slog_term::TermDecorator::new().build();
    let drain = slog_term::FullFormat::new(decorator).build().fuse();
    let drain = slog_async::Async::new(drain).build().fuse();

    let log = slog::Logger::root(drain, o!());
    let _guard = slog_scope::set_global_logger(log);

    slog_scope::scope(&slog_scope::logger().new(o!()), || run());
}

fn run() {
    let version = VERSION.unwrap_or("0.0.0");
    info!("Starting tagon-os-mgmtd, version: {}", version);

    let config = match envy::from_env::<Config>() {
        Ok(config) => config,
        Err(error) => {
            error!("Failed to retrieve config from environment: {}", error);
            std::process::exit(1);
        }
    };

    info!("Loaded config: {:?}", config);

    loop {
        std::thread::sleep(std::time::Duration::from_secs(10));
        info!("Running");
    }
}
