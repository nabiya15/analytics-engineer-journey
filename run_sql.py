import duckdb
import sys

if len(sys.argv) < 2:
    print("Usage: python run_sql.py <path_to_sql_file>")
    sys.exit(1)

conn = duckdb.connect()
sql = open(sys.argv[1]).read()

for statement in [s.strip() for s in sql.split(';') if s.strip()]:
    try:
        result = conn.execute(statement)
        if result.description:
            print(result.fetchdf().to_string(index=False))
            print()
    except Exception as e:
        print(f"Error: {e}")