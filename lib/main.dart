import 'package:flutter/material.dart';
import 'crypto.dart';
import 'api_service.dart';

void main() {
  runApp(CryptoPriceApp());
}

class CryptoPriceApp extends StatefulWidget {
  @override
  _CryptoPriceAppState createState() => _CryptoPriceAppState();
}

class _CryptoPriceAppState extends State<CryptoPriceApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Price App',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home:
          CryptoPriceHomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class CryptoPriceHomePage extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  CryptoPriceHomePage({required this.toggleTheme, required this.isDarkMode});

  @override
  _CryptoPriceHomePageState createState() => _CryptoPriceHomePageState();
}

class _CryptoPriceHomePageState extends State<CryptoPriceHomePage> {
  late Future<List<Crypto>> futureCryptoData;

  @override
  void initState() {
    super.initState();
    futureCryptoData = ApiService().fetchCryptoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Prices'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon:
                  Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: () => widget.toggleTheme(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: EdgeInsets.all(16.0),
            color: widget.isDarkMode ? Colors.grey[850] : Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cryptocurrency Rankings',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Cryptocurrency Rankings by Muhammad Ryan Aziza Parasudewa dengan NIM 211011401529 untuk UAS Mobile Programing',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          // Crypto List
          Expanded(
            child: FutureBuilder<List<Crypto>>(
              future: futureCryptoData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Crypto crypto = snapshot.data![index];
                      return _buildCryptoCard(crypto, widget.isDarkMode);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(Crypto crypto, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hapus bagian Image.network untuk logo
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${crypto.name} (${crypto.symbol})',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Price: \$${crypto.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${crypto.change.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: crypto.change < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'MCap: \$${crypto.marketCap.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
              Text(
                'Vol: \$${crypto.volume.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
