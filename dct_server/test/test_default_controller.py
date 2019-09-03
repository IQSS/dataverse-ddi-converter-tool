# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from dct_server.test import BaseTestCase


class TestDefaultController(BaseTestCase):
    """DefaultController integration test stubs"""

    def test_convert_ddi(self):
        """Test case for convert_ddi

        Convert DDI
        """
        body = Object()
        response = self.client.open(
            '/api/convert/{target}/{token}'.format(target='target_example', token='token_example'),
            method='POST',
            data=json.dumps(body),
            content_type='application/octet-stream')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
