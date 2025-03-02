import 'package:flutter/material.dart';
import '../models/country_code.dart';

class CountryCodeDropdown extends StatefulWidget {
  final Function(CountryCode) onChanged;
  final CountryCode? initialSelection;
  final bool showCommonOnly;

  const CountryCodeDropdown({
    Key? key,
    required this.onChanged,
    this.initialSelection,
    this.showCommonOnly = true,
  }) : super(key: key);

  @override
  State<CountryCodeDropdown> createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  late CountryCode _selectedCountry;
  bool _isExpanded = false;
  late List<CountryCode> _countries;
  final TextEditingController _searchController = TextEditingController();
  List<CountryCode> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _countries =
        widget.showCommonOnly
            ? CountryCode.getCommonCountries()
            : CountryCode.getAllCountries();
    _selectedCountry = widget.initialSelection ?? _countries.first;
    _filteredCountries = List.from(_countries);
  }

  void _filterCountries(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCountries = List.from(_countries);
      });
      return;
    }

    setState(() {
      _filteredCountries =
          _countries
              .where(
                (country) =>
                    country.name.toLowerCase().contains(query.toLowerCase()) ||
                    country.dialCode.contains(query) ||
                    country.code.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (!_isExpanded) {
                _searchController.clear();
                _filteredCountries = List.from(_countries);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedCountry.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedCountry.dialCode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Card(
            margin: const EdgeInsets.only(top: 4),
            elevation: 4,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search country',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _filterCountries,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                              _isExpanded = false;
                              _searchController.clear();
                              _filteredCountries = List.from(_countries);
                            });
                            widget.onChanged(country);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      country.flag,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        country.name,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  country.dialCode,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = false;
                          widget.showCommonOnly
                              ? _countries = CountryCode.getAllCountries()
                              : _countries = CountryCode.getCommonCountries();
                          _filteredCountries = List.from(_countries);
                        });
                      },
                      child: Text(
                        widget.showCommonOnly
                            ? 'Show All Countries'
                            : 'Show Common Countries',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
