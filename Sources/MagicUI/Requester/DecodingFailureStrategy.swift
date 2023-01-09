//
//  DecodingFailureStrategy.swift
//  RequesterDemo
//
//  Created by Alex Nagy on 26.12.2022.
//

import Foundation

/// The strategy to use when an error occurs during mapping
///
public enum DecodingFailureStrategy {
  /// Ignore any errors that occur when mapping.
  case ignore

  /// Raise an error when mapping fails.
  case raise
}
