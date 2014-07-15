files
=====

This package defines filesystem APIs that can be implemented for different
environments such as dart:io, Chrome Apps, or network filesystems.

The API includes `FileSystem`, `File` and `Directory` classes with interfaces
similar to those in dart:io, excluding synchronous operations and constructors.

All `File` and `Directory` implementations should not have public constructors,
and instances should only be retreived via a `FileSystem` instance. This ensures
that code that uses the interfaces defined here can work with any
implementations.

## Status

This is a work in progress and not ready for production use. Implementation and
tests and being fleshed out now.

## Contributions Welcome

We'd like to have implementations for various situations and file storage APIs,
including in-memory, proxy filesystems that work across Isolates, clound storage
services like Google Cloud Storage and Amazon S3, standard protocols like
WebDAV, wrappers that provide a transformed view of another file system, etc.

Not all implementations have to live in this package, but a few core ones
should. The more implementations we have early, the better tested the APIs will
be.
