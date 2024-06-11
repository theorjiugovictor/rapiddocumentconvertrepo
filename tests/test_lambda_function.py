import unittest
from src.lambda_function import extract_text

class TestLambdaFunction(unittest.TestCase):
    def test_extract_text(self):
        sample_response = { 'Blocks': [] }  # Mock Textract response
        result = extract_text(sample_response)
        self.assertEqual(result, "expected text")

if __name__ == '__main__':
    unittest.main()
