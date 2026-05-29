import 'package:flutter/material.dart';
class ProfileBox extends StatelessWidget {
  const ProfileBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 300,
      padding: const EdgeInsets.all(20.0), // Padding inside the box
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
        border: Border.all(color: Colors.grey[300]!, width: 1), // Optional border
      ),
      // 2. The Row (for horizontal arrangement)
      child: Row(
        // center vertically within the row
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 3. Child 1: The Profile Picture
          const CircleAvatar(
            radius: 40, // Controls the size of the circle
            // You can use a network image, asset image, or just a background color/icon
            backgroundColor: Colors.blueAccent, // Fallback color
            child: Icon(Icons.person, size: 50, color: Colors.white), // Default icon
            // backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Uncomment to use an image URL
          ),

          // 4. Child 2: A horizontal spacer
          const SizedBox(width: 20), // Add some space between the pic and name

          // 5. Child 3: The Name (and other details if needed)
          Column(
            // Align the name to the left/start within the column
            crossAxisAlignment: CrossAxisAlignment.start,
            // (Optional) Center the column vertically relative to the Row's children
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 4), // Small vertical space
              const Text(
                'User Profile', // Subtitle or extra detail
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
