from flask import Flask

def create_app():
    app = Flask(__name__)

    from .routes.home_routes import home_bp
    from .routes.athlete_routes import athlete_bp
    from .routes.match_routes import match_bp

    app.register_blueprint(home_bp)
    app.register_blueprint(athlete_bp, url_prefix='/athlete')
    app.register_blueprint(match_bp, url_prefix='/matches')

    return app