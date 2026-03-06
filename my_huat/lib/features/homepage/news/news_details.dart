import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1080E7),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "News Detail",
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  child: Image.asset(
                    news['image'],
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFF0D3A6D).withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: const Color(0xFF0462C2),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        news['date'],
                        style: TextStyle(
                          color: const Color(0xFF05509F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    news['title'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D3A6D),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Render details if available, else fallback to simple content
                  if (news.containsKey('details') && news['details'] != null)
                    ..._buildSections(news['details'])
                  else
                    // Fallback to original content
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0EDFE).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFBBDBFC),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        news['content'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF084584),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(List<dynamic> sections) {
    return sections.map((section) {
      switch (section['type']) {
        case 'header':
          return _buildHeader(section['data']);
        case 'subheader':
          return _buildSubHeader(section['data']);
        case 'paragraph':
          return _buildParagraph(section['data']);
        case 'bullet_list':
          return _buildBulletList(section['data']);
        case 'numbered_list':
          return _buildNumberedList(section['data']);
        case 'table':
          return _buildTable(section['data']);
        case 'link':
          return _buildLink(section['data']);
        default:
          return const SizedBox.shrink();
      }
    }).expand((widget) => [widget, const SizedBox(height: 12)]).toList();
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D3A6D),
        ),
      ),
    );
  }

  Widget _buildSubHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0D3A6D),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF084584)),
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6, right: 8),
                child: Icon(Icons.circle, size: 6, color: Color(0xFF0D3A6D)),
              ),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 15, color: Color(0xFF084584)))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumberedList(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 8),
                child: Text(
                  "${index + 1}.",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0D3A6D)),
                ),
              ),
              Expanded(child: Text(steps[index], style: const TextStyle(fontSize: 15, color: Color(0xFF084584)))),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTable(Map<String, dynamic> tableData) {
    List<String> headers = tableData['headers'].cast<String>();
    List<List<String>> rows = List<List<String>>.from(tableData['rows'].map((r) => List<String>.from(r)));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBBDBFC)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Table(
        columnWidths: {for (int i = 0; i < headers.length; i++) i: FlexColumnWidth()},
        children: [
          // Header row
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFE0EDFE)),
            children: headers.map((h) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  h,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D3A6D)),
                ),
              );
            }).toList(),
          ),
          // Data rows
          ...rows.map((row) {
            return TableRow(
              children: row.map((cell) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    cell,
                    style: const TextStyle(color: Color(0xFF084584)),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLink(String text) {
    return GestureDetector(
      onTap: () {
        // TODO: handle link tap
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1080E7),
          decoration: TextDecoration.underline,
          fontSize: 15,
        ),
      ),
    );
  }
}