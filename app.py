import os
from flask import Flask, render_template
import pymysql
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

DB_HOST = os.environ.get('DB_HOST', 'localhost')
DB_USER = os.environ.get('DB_USER', 'root')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'password')
DB_NAME = os.environ.get('DB_NAME', 'mydatabase')

def get_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/')
def index():
    connection = get_connection()
    with connection.cursor() as cursor:
        # Increment the visitor count
        cursor.execute("UPDATE visitors SET count = count + 1 WHERE id = 1;")
        
        # Fetch the updated count
        cursor.execute("SELECT count FROM visitors WHERE id = 1;")
        visitor_result = cursor.fetchone()
        
        # Fetch a random GIF
        cursor.execute("SELECT url FROM gifs ORDER BY RAND() LIMIT 1;")
        gif_result = cursor.fetchone()
        
        # Commit the transaction to save changes
        connection.commit()
        
    connection.close()
    
    # Extract the visitor_count and gif_url
    visitor_count = visitor_result['count'] if visitor_result else 0
    gif_url = gif_result['url'] if gif_result else None

    return render_template('index.html', gif_url=gif_url, visitor_count=visitor_count)

if __name__ == '__main__':
    # Use the environment variables for host/port if available
    host = os.environ.get('FLASK_RUN_HOST', '0.0.0.0')
    port = int(os.environ.get('FLASK_RUN_PORT', 5000))
    app.run(host=host, port=port, debug=True)