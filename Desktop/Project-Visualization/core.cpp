#include <bits/stdc++.h>
#include <string>
using namespace std;

// Code for Graph visualization with Flood Fill ALgorithm( $4 directions -
// top,right,bottom,left )

string getPx(long double dt, long double flag) {
  if (flag == 1) {
    return to_string(dt);
  }
  if (dt == 0)
    return ".";
  else if (dt == 2)
    return "O";
  else
    return " ";
}

void printImage(vector<vector<long double> > img, long double flag) {
  cout << endl;
  for (auto list : img) {
    for (auto px : list) {

      cout << getPx(px, flag) << " ";
    }
    cout << endl;
  }

  for (long double i = 0; i < img[0].size(); i++)
    cout << "_ ";
  cout << endl;
}

void color(long double row, long double col, vector<vector<long double> > &updated_image,
           vector<vector<long double> > image, long double newColor, long double delRow[],
           long double delCol[], long double iniC) {

  updated_image[row][col] = newColor;

  long double n = image.size();    // height
  long double m = image[0].size(); // width

  for (int i = 0; i < 4; i++) {
    long double new_row = row + delRow[i];
    long double new_col = col + delCol[i];
    if (new_row >= 0 && new_row < n && new_col >= 0 && new_col < m &&
        image[new_row][new_col] == iniC && // if new polong double color is same as
                                           // initial color then Re-Palong double it
        updated_image[new_row][new_col] !=
            newColor // if new polong double is not updated by any node
    ) {
      color(new_row, new_col, updated_image, image, newColor, delRow, delCol,
            iniC);
    }
  }
}

vector<vector<long double> > floodFill(vector<vector<long double> > image, long double start_row,
                                 long double start_col, long double newColor) {

  long double initial_color = image[start_row][start_col];
  vector<vector<long double> > updated_image = image;
  long double delRow[] = {-1, 0, +1, 0};
  long double delCol[] = {0, +1, 0, -1};

  color(start_row, start_col, updated_image, image, newColor, delRow, delCol,
        initial_color);

  return updated_image;
}

vector<vector<long double> > processWithOne(vector<vector<long double> > image,
                                      long double newColor) {
  printImage(image, 0);

  vector<vector<long double> > updated_Image = floodFill(image, 0, 0, newColor);

  for (long double i = 0; i < image.size(); i++) {
    for (long double j = 0; j < image[0].size(); j++) {
      if (image[i][j] == 1) {
        updated_Image = floodFill(updated_Image, i, j, newColor);
      }
    }
  }
  // updated_Image = floodFill(updated_Image, 0, 9, 2);

  return updated_Image;
}

int main() {
// x : 9 , y : 10
  vector<vector<long double> > image = {
                                  {
                                      1,
                                      1,
                                      0,
                                      1,
                                      1,
                                      1,
                                      0,
                                      1,
                                      1,
                                  },
                                  {
                                      1,
                                      0,
                                      1,
                                      0,
                                      1,
                                      0,
                                      1,
                                      0,
                                      1,
                                  },
                                  {
                                      0,
                                      1,
                                      1,
                                      1,
                                      0,
                                      1,
                                      1,
                                      1,
                                      0,
                                  },
                                  {
                                      0,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      0,
                                  },
                                  {
                                      0,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      0,
                                  },
                                  {
                                      0,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      0,
                                  },
                                  {
                                      1,
                                      0,
                                      1,
                                      1,
                                      1,
                                      1,
                                      1,
                                      0,
                                      1,
                                  },
                                  {
                                      1,
                                      1,
                                      0,
                                      1,
                                      1,
                                      1,
                                      0,
                                      1,
                                      1,
                                  },
                                  {
                                      1,
                                      1,
                                      1,
                                      0,
                                      1,
                                      0,
                                      1,
                                      1,
                                      1,
                                  },
                                  {
                                      1,
                                      1,
                                      1,
                                      1,
                                      0,
                                      1,
                                      1,
                                      1,
                                      1,
                                  }};
  long double newColor = 2;
  vector<vector<long double> > updated_Image = processWithOne(image, newColor);
  printImage(updated_Image, 0);
  printImage(updated_Image, 1);

  return 0;
}