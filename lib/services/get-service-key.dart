import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "storeadminpanel",
        "private_key_id": "b6b3398a59aa30b29251d4ad25c0e802d18f8145",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDgwq+J4cD8Ca5O\n4RNUTkSw+nPrZVKMMn+n0rohXzvJ4kih3X0oYIJVz4cPp14aViEzRHJzsq/9OJbF\n+26QBMar9ddBphj0CTI9dOh3NYHGuu6SoiY7VIdYSNr/Re9c/ZWpiNMDaUlcoPKE\nkD3ATS7IUKKOx+FwUSXVo/aKfqDyCdSz3spsaFL3zd/j2Kt8leGmx3pudoOxA6rc\nbXjwxAXMVNEY0/WgRogBDA+HU8gGCBw1R6bhnN3N+nL3RfpeAh/nJ8Vc2c1Gi2vC\nktZeHtRMRzKVYrJGowUEK9GV/J3qM4LfImIcylsrESva+WKgeXxcjq50RmtBR6ZC\n76cTfsLhAgMBAAECggEADoCpbHtvZSPnximyQliZiJTkiW4chTTV9Vl8zp3zQOvT\ntXQR+Rq/FjPhmmI5iXgAxOrX+ryvK+bsnaJDaFISkrJ2fQMvbYGxZvNF87k1YkIa\nFkaVsnLaF9l9ngagcw7eyxVrzjbLN8mf1GttPJ0OVXkUgCOIGaP2zcH6bMXOc0eN\npxQx7rymx14pA2BIeh4ogbe2paeKgE5GjJ5iSNGjzPx40F52Cey0Zgyu7OA34hno\nQNWQzuRWCJSOuOqhyhtemEw+vpBdW7rkSCECS1JU1VF7D2St7wtnAVerdOtEW2u5\nR2CetroA0yktZ898Sgi5/TiwTjgYs4pAPHUqtwshkQKBgQDzqO3tk44pxMtGIRJF\nXdt652kYwmQ928nJGoKU4d5MF7Ylaqnx8BWojxoW1+3GXYHhA5NHfTAi/SzjXcOO\noD+Vs0/xm+b85faE/gI+vVx4lf74I9Djnm7oGNORmGmGv5ieQ+zH2bjaekc1eReg\njS+a1YI3+0GQiRQXIEOrIU0piQKBgQDsJLlhAXAVEbfMSu/v1bYM2ywsaB8JcL8e\nnqSgk4ppaM9Lcx94o7CxwPj678WcTGIRj0bpTOWg7PKXhD06hkhJS7CJE5dkJQ7D\ngNICHAHHDU03BAbWcBCDfHGVBqBoQsUbLNbyKERlmuOgY42icWyZHLP0Yda+j6TS\n+INSjE1wmQKBgQDCGqDv0cw+mfcVNuNHPy3JCvA+OR2B6cUl32iHEif0li8UP5SC\nl6+pR9aQvBM/It6EUkTRfnkKZoWL2vYeeKoup1nYL0ojzU5FQ9SmBlPT/CnRozaV\nHXFck+p24eOu5JLAAXxu+JK5+Q8hGgYocFCsF8pUrmPcsFbA1YMSoMTHgQKBgQDS\nsL15sJe5JLLRorbLTOl+NPsHr+qpOKA9CJyn7JvdCreRgOi+cYYQQrWi5tVwa7JA\nKo7BT2u+FksoJsOeePr78n1TAFjd8DZo9oHpgeWQHO0cvgn/v8LsHdcVePEbtR85\n7Nrm+kh0Qyr/CnPvULXtMm/ZBoZcRbtwxGwe9bGOWQKBgQDMURb/ExVZAMsjerFx\nvxYE7Uzu0Xar1aQ2/j0e+u1miBeejwOepWY75zwFQGbxE5ew4NIczSfeRQ3ZAxPT\nMOdfcvc33Lte2bQE0sZxjVY0tTFq+g8wd8ZiW0n7AmUrs/RZZ1YxBZoEwSPuxk3i\nLDDvcR57OIv9nAjMSsNpyhL0eA==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-p98cz@storeadminpanel.iam.gserviceaccount.com",
        "client_id": "109546645507186513183",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-p98cz%40storeadminpanel.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
